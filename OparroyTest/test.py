#!/usr/bin/env python3
import serial
import struct
import sys
import time
import csnd6

"""
  state        |  cause    |  next state            |  effect
 -------------------------------------------------------------------
 RESET         |           | wait_start             | init everything
 wait_start    | rx fall   | measure_start          | start timer
 measure_start | rx rise   | wait_command           | init uart with measured baud. tx(0xff)
 wait_command  | rx & 0x80 | set                    | tx(rx), offset=(rx & 0x7f) - 1
               | rx==0     | sync                   | tx(rx)
               | rx        | get                    | tx(rx), offset=rx - 1

 set           | rx        | set(rx-1)              |
 set(n)        | rx        | set(n-1)               | data[offset + n] = rx
 set(0)        | rx        | set_nxt                | data[offset + 0] = rx
 set_nxt       | rx==0     | wait_start             | tx(0)
               | rx        | fwd(rx-1,set_nxt)      | tx(rx)

 sync          | rx        | wait_start             | tx(rx-1)

 get           | rx        | get_nxt                | tx(rx), length = rx
 get_nxt       | rx==0     | get(length-1)          | tx(length)
               | rx        | fwd(length-1, get_nxt) | tx(length)
 get(n)        | tx rdy    | get(n-1)               | tx(data[offset + n])
 get(0)        | tx rdy    | get_end                | tx(data[offset + 0])
 get_end       | tx rdy    | wait_start             | tx(0)
 
 fwd(n,r)      | rx        | fwd(n-1,r)             | tx(rx)
 fwd(0,r)      | rx        | r                      | tx(rx)
"""


class Oparroy:
	n_devices = None
	def __init__(self, dev, baud=1000000):
		self.s = serial.Serial(dev, baud, timeout=0.1)
		self.n_devices = self.sync()
		print("{} device(s) found:".format(self.n_devices))
		for s in self.read_serial():
			print("\t0x{:x}".format(s))

	def sync(self):
		self.s.write(b"\xff\x00\xff")
		#self.s.flush();
		reply = self.s.read(3)
		assert len(reply) == 3, reply
		autobaud, cmd, count = struct.unpack("BBB", reply)
		assert autobaud == 0xff, autobaud
		assert cmd == 0, cmd
		n_devices = 0xff - count
		assert self.n_devices is None or self.n_devices == n_devices, count
		return n_devices

	def set1(self, offset, data):
		assert offset >= 0 and offset + 1 < 0x80
		cmd = (offset + 1) | 0x80
		rdata = bytes(reversed(data))
		self.s.write(b"\xff"+struct.pack("BB", cmd, len(data))+rdata+b"\x00")
		autobaud, rcmd, eof = struct.unpack("BBB", self.s.read(3))
		assert autobaud == 0xff, autobaud
		assert rcmd == cmd, (rcmd, cmd)
		assert eof == 0, eof

	def get1(self, offset, length):
		assert offset >= 0 and offset + 1 < 0x80
		assert length > 0 and length <= 0xff
		cmd = offset + 1
		self.s.write(b"\xff"+struct.pack("BB", cmd, length)+b"\x00")
		r = self.s.read(4+length)
		assert len(r) == 4 + length, r
		autobaud, rcmd, rlength = struct.unpack("BBB", r[:3])
		assert rlength == length, (rlength, length)
		assert r[-1] == 0, r
		return bytes(reversed(r[3:-1]))

	def get2(self):
		self.s.write(b"\xff\x01\x02\x02AB\x02CD\x00")
		print(self.s.read(20))

	def set2(self):
		self.s.write(b"\xff\x81\x02AB\x02CD\x00")
		print(self.s.read(20))
	

	def set(self, offset, data):
		assert len(data) == self.n_devices, (len(data), self.n_devices)
		for x in data[1:]:
			assert len(x) == len(data[0])
		assert offset >= 0 and offset + 1 < 0x80
		cmd = (offset + 1) | 0x80
		send = b"\xff" + struct.pack("B", cmd)
		for x in data:
			send += struct.pack("B", len(x)) + bytes(reversed(x))
		send += b"\x00"
		self.s.write(send)
		autobaud, rcmd, eof = struct.unpack("BBB", self.s.read(3))
		assert autobaud == 0xff, autobaud
		assert rcmd == cmd, (rcmd, cmd)
		assert eof == 0, eof

	def get(self, offset, length):
		assert offset >= 0 and offset + 1 < 0x80
		assert length > 0 and length <= 0xff
		cmd = offset + 1
		self.s.write(b"\xff"+struct.pack("BB", cmd, length)+b"\x00")
		r = self.s.read(4 + (length + 1) * self.n_devices)
		autobaud, rcmd, rlength = struct.unpack("BBB", r[:3])
		assert autobaud == 0xff, autobaud
		assert rcmd == cmd, (rcmd, cmd)
		assert rlength == length, (rlength, length)
		assert r[-1] == 0, r
		ret = []
		for i in range(self.n_devices):
			assert r[3+i*(length + 1)] == length
			rdata = r[4+i*(length + 1):4+i*(length + 1)+length]
			ret.append(bytes(reversed(rdata)))
		return ret

	def read_adc(self):
		self.sync()
		return [struct.unpack("<H", x)[0] for x in self.get(8, 2)]

	def read_serial(self):
		return [struct.unpack("<I", x)[0] for x in self.get(0, 4)]

	def set_pwm(self, values):
		self.set(0x20, [struct.pack("<HHH", *v) for v in values])
		self.sync()


def main(dev, csound_file):
	s = Oparroy(dev, baud=1000000)
	
	now = time.time()
	i = 0
	OparroyToggle0 = 0

	MASK = (1<<11)-1
	while True:
        cs = csnd6.Csound()
        res = cs.Compile(csound_file)
        if res == 0:
            perf = csnd6.CsoundPerformanceThread(cs)
            perf.Play()
            last = now
			#adc = s.read_adc()
			#s.sync()
			#adc = s.get(0, 64)
			PWM0 = cs.GetChannel("OparroyPWM_0")
			s.set_pwm(PWM0)

			#three = (50*i) & MASK
			#s.set_pwm([(i & MASK, (2*i) & MASK, three)])
			i += 1
			now = time.time()
			print("{} cycle {:x} {:5.2f} ms".format(i, three, 1000*(now-last)))

			adc = s.read_adc()

			cs.SetChannel("OparroyAnaloge0", adc[0])
			#cs.SetChannel("OparroyToggle0")



	while True:
		#time.sleep(0.05)
		s.set1(2, b"h")
		s.set1(3, b"e")
		s.set1(4, b"l")
		s.set(5, [b"LO"])
		#time.sleep(0.05)
		print(s.get(0, 8))
		s.get2()
		#s.set2()
		print(s.get(0, 64))
		return

if __name__ == "__main__":
	main(sys.argv[1])