import pcapy
import argparse
import random

from pythonosc import udp_client, osc_message_builder

# Listen for packets on interface `wlp4s0`
# w = pcapy.open_live("wlp3s0", 255, 1, 0)
# w.setfilter("arp")
# i = 0
# while True:
#     (header, packet) = w.next()
#     i = i + 1
#     print("got another: %r" % i)
#    print(header)

# Parse command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument("--ip", default="127.0.0.1")
parser.add_argument("--port", type=int, default=5005)
args = parser.parse_args()


# Send a simple OSC message
client = udp_client.SimpleUDPClient(args.ip, args.port)
client.send_message("/filter", random.random())
