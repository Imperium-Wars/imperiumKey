#!/usr/bin/env python3
import sys

from starkware.crypto.signature.fast_pedersen_hash import pedersen_hash
from starkware.crypto.signature.signature import private_to_stark_key, sign

# params
argv = sys.argv
if len(argv) < 2:
    print("[ERROR] Invalid amount of parameters")
    print("Usage: ./whitelist.py priv_key receiver_address")
    quit()
priv_key = argv[1]
receiver_address = argv[2]

# compute signature
signed = sign(int(receiver_address), int(priv_key))
print("signature:", signed)
