#!/usr/bin/env python3
import sys
import json
from starkware.crypto.signature.signature import  sign

# params
argv = sys.argv
if len(argv) < 2:
    print("[ERROR] Invalid amount of parameters")
    print("Usage: .tools/whitelist.py priv_key")
    sys.exit()
priv_key = argv[1]

whitelists_data = dict()

def verify_string(s):
    if s.startswith('0x'):
        return s
    else:
        return ""

# compute signature
with open('./tools/whitelists.json') as json_file:
    whitelistedAddresses = json.loads(json_file.read())
    
for i in range(len(whitelistedAddresses)):
    if bool(whitelistedAddresses[i]["address"]) or bool(whitelistedAddresses[i]["answer"]):
        address = verify_string(whitelistedAddresses[i]["address"] if whitelistedAddresses[i]["address"] else whitelistedAddresses[i]["answer"])
        if address.startswith("0x"):
            whitelists_data[int(address, 16)] = []
            print(address)
            signed = sign(int(address, 16), int(priv_key)) 
            whitelist_info = [str(signed[0]), str(signed[1])],
            whitelists_data[int(address, 16)].append(whitelist_info)
    
with open('./tools/whitelistsdata.json', 'w') as json_file:
    json_object = json.dumps(whitelists_data)
    json_file.write(json_object)

