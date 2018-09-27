package main

import (
    "fmt"
    "os"
    "flag"

    "github.com/google/gopacket"
    "github.com/google/gopacket/layers"
    "github.com/google/gopacket/pcap"
    "github.com/hypebeast/go-osc/osc"
)

var (
    port  int
    ip    string
    iface string
)

func flags() {
    flag.IntVar(&port, "port", 5005, "Port to send OSC message to")
    flag.StringVar(&ip, "ip", "127.0.0.1", "IP to send OSC messages to")
    flag.StringVar(&iface, "iface", "wlp3s0", "Interface to listen for packets on")

    flag.Parse()

    fmt.Printf("listening on %s:%d\n", ip, port)
    fmt.Printf("iface: %s\n", iface)

    if iface == "" {
        fmt.Fprintln(os.Stderr, "usage: snoop -iface <interface>")
        os.Exit(1)
    }
}

// Listen on a network interface, filtering the messages with the BPF filter,
// and calling fn on the resulting packet.
func listen(iface string, filter string, fn func(packet gopacket.Packet) []*osc.Message) error {

    client := osc.NewClient(ip, port)

    handle, err := pcap.OpenLive(iface, 1600, true, pcap.BlockForever)
    if err != nil {
        return err
    }

    if filter != "" {
        err := handle.SetBPFFilter(filter)
        if err != nil {
            return err
        }
    }

    src := gopacket.NewPacketSource(handle, handle.LinkType())
    for packet := range src.Packets() {
        msgs := fn(packet)
        for _, msg := range msgs {
            client.Send(msg)
        }
    }

    return nil
}

// Convert Ethernet packets into arrays of OSC messages
// XXX: a lot of unnecessary repeated code in here
func handler(p gopacket.Packet) []*osc.Message {

    transport := p.TransportLayer()
    application := p.ApplicationLayer()

    var msgs []*osc.Message

    if application != nil {
        if application.LayerType() == layers.LayerTypeDNS {
            msg := osc.NewMessage("/dns")
            msg.Append("hello")
            msgs = append(msgs, msg)
        }
    }

    if transport != nil {
        if transport.LayerType() == layers.LayerTypeTCP {
            msg := osc.NewMessage("/tcp")
            msg.Append("hello")
            msgs = append(msgs, msg)
        } else if transport.LayerType() == layers.LayerTypeUDP {
            msg := osc.NewMessage("/udp")
            msg.Append("hello")
            msgs = append(msgs, msg)
        }
    }

    return msgs
}

func main() {

    flags()

    err := listen(iface, "", handler)
    if err != nil {
        fmt.Fprintf(os.Stderr, "%v\n", err)
    }
}
