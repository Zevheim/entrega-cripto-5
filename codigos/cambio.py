from scapy.all import rdpcap, wrpcap, Raw, IP, TCP

# Input and output pcap file paths
original_pcap = 'cliente_3.pcapng'
modified_pcap = 'otro.pcapng'

# IP address of the client to modify
client_ip = '172.18.0.5'  # Update with the actual IP of the client

# Read the pcap file
packets = rdpcap(original_pcap)

# Desired length of the SSH protocol section
desired_length = 85

# Process each packet in the capture
for pkt in packets:
    # Check if the packet contains a Raw layer with the target SSH version string
    if pkt.haslayer(Raw) and pkt[Raw].load:
        if b'SSH-2.0-OpenSSH_8.3p1 Ubuntu-1ubuntu0.1' in pkt[Raw].load:
            # Modify the packet if it originates from the specified client IP
            if pkt[IP].src == client_ip:
                # Replace the SSH version string
                pkt[Raw].load = pkt[Raw].load.replace(b'SSH-2.0-OpenSSH_8.3p1 Ubuntu-1ubuntu0.1', b'SSH-2.0-OpenSSH_?')
                
                # Clear the checksums and length to force recalculation
                del pkt[IP].len
                del pkt[IP].chksum
                if pkt.haslayer(TCP):
                    del pkt[TCP].chksum

# Save the modified packets to a new pcap file
wrpcap(modified_pcap, packets)
