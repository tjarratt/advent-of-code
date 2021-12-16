#!/usr/bin/env ruby

def main(filename)
    puts filename
    bytes = File.read(filename)
        .split('')
        .map {|b| b.to_i(16).to_s(2).rjust(4, '0') }
        .join('')

    # first 3 are the version
    # next 3 are the package type
    # literal value : next five start with 1 (keep reading)
    #                 take the last four bytes
    # next five start with 1 (keep reading)
    #                 take the last four bytes
    # next five start with 0 (last group)
    #                 take the last four bytes
    # ignore any trailing zeroes

    puts PacketBuilder.build(bytes).map(&:version).flatten.inject(:+)
    puts
end

class PacketBuilder
    def self.build(bytes)
        packets = []
        while valid?(bytes)
            p, read = case bytes[3..5].to_i(2)
            when 4
                build_literal_packet(bytes)
            else
                build_operator_packet(bytes)
            end

            packets << p
            bytes = bytes[read..]
        end
        packets
    end

    def self.valid?(bytes)
        return false if bytes.nil?

        bytes.split('').any? {|b| b == '1' }
    end

    def self.build_operator_packet(bytes)
        version = bytes[0..2].to_i(2)
        type = bytes[3..5].to_i(2)
        length_type = bytes[6].to_i(2)

        sub_packets, read = case length_type
        when 0
            # read next 15 bits as total length of bits of sub packtes
            length_in_bits = bytes[7..21].to_i(2)
            read_up_to = 22 + length_in_bits
            sub = bytes[22..read_up_to - 1]
            packets = build(sub)
            [packets, read_up_to]
        when 1
            # next 11 bits are number of sub-packets 
            packets = []
            read_up_to = 18
            num = bytes[7..read_up_to - 1].to_i(2)
            num.times do |index|
                packets << case bytes[read_up_to + 3..read_up_to + 5].to_i(2)
                when 4
                    sub = bytes[read_up_to..]
                    p, up_to = build_literal_packet(sub)
                    read_up_to += up_to
                    p
                else
                    sub = bytes[read_up_to..]
                    p, up_to = build_operator_packet(sub)
                    read_up_to += up_to
                    p
                end
            end
            [packets, read_up_to]
        else
            raise 'wtf'
        end
        
        [OperatorPacket.new(version, type, sub_packets), read]
        
    end

    def self.build_literal_packet(bytes)
        version = bytes[0..2].to_i(2)
        type = bytes[3..5].to_i(2)

        payload = []

        index = 6
        read = -1
        loop do
            read = index + 4
            payload << bytes[index+1..(index + 4)]
            break if bytes[index] == '0'
            index += 5
        end

        payload = payload.join('').to_i(2)
        [LiteralPacket.new(version, type, payload), read + 1]
    end
end

class OperatorPacket
    def initialize(version, type, sub_packets)
        @version = version
        @type = type
        @sub_packets = sub_packets
    end

    def version
        @version + @sub_packets.map(&:version).inject(:+)
    end

    def to_s
        "operator packet -> version (#{@version}) : type (#{@type}) : sub_packets (#{@sub_packets.map(&:to_s)})"
    end
end

class LiteralPacket
    attr_reader :version

    def initialize(version, type, payload)
        @version = version
        @type = type
        @payload = payload
    end

    def to_s
        "literal packet -> version (#{@version}) : type (#{@type}) : payload (#{@payload})"
    end
end

main('test-1.txt')
main('test-2.txt')
main('test-3.txt')
main('test-4.txt')
main('test-5.txt')
main('test-6.txt')
main('test-7.txt')

main('input.txt')
