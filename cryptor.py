import sys
import base64
import hashlib
from Crypto import Random
from Crypto.Cipher import AES
from subprocess import Popen, PIPE, STDOUT
from argparse import ArgumentParser

parser = ArgumentParser("AES Shellcode Cryptor")
parser.add_argument("-sc", "--shellcode", help="Shellcode To Encrypt")
parser.add_argument("-k", "--key", help="Input Secret Key")
args = parser.parse_args()


# AES divides blocks of 16 bytes in length before encrypting, to support code that is smaller then 16 bytes
BS = 16
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS).encode()
unpad = lambda s: s[:-ord(s[len(s)-1:])]

class AESCipher:
    def __init__(self, key):
        # Hash the key to a mask of 64 bytes to have a fixed length to be used to generate a random byte string
        # During Encryption process
        self.key = hashlib.sha256(key.encode('utf-8')).digest()

    def encrypt(self, raw):
        raw = pad(raw)
        iv = Random.new().read(AES.block_size)
        cipher = AES.new(self.key, AES.MODE_CBC, iv)
        return base64.b64encode(iv + cipher.encrypt(raw.encode('utf8')))

    def decrypt(self, enc):
        enc = base64.b64decode(enc)
        iv = enc[:16]
        cipher = AES.new(self.key, AES.MODE_CBC, iv)
        return unpad(cipher.decrypt( enc[16:]))


if args.shellcode:
    sc = args.shellcode

if args.key:
    secret = args.key

cmd = "objdump -d {} | grep '^ '  | cut -f 2".format(sc)
proc = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT, close_fds=True)
proc = proc.stdout.read()
shellcode = br"\x" + br"\x".join(proc.split())

cipher = AESCipher(secret)
encrypted = cipher.encrypt(shellcode)
decrypted = cipher.decrypt(encrypted)
print("[*] Printing Encrypted Shellcode")
print("--------------------------------")
print(encrypted)
print
print("[*] Printing Original Shellcode")
print("--------------------------------")
print(decrypted)
