#!/usr/bin/env ruby

def main
    #part_1('test-1.txt')
    #part_1('test-2.txt')
    #part_1('test-3.txt')
    #part_1('test-4.txt')
    #part_1('test-5.txt')
    #part_1('test-6.txt')
    #part_1('test-7.txt')
    part_1('input.txt')

    #part_2('C200B40A82')
    #part_2('04005AC33890')
    #part_2('880086C3E88112')
    #part_2('CE00C43D881120')
    #part_2('D8005AC2A8F0')
    #part_2('F600BC2D8F')
    #part_2('9C005AC2F8F0')
    #part_2('9C0141080250320F1802104A08')
    part_2(File.read('input.txt'))
end

def part_1(filename)
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

def part_2(input)
    bytes = input.split('')
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

    puts PacketBuilder.build(bytes).map(&:value).flatten.inject(:+)
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

    def value
        case @type
        when 0
            @sub_packets.map(&:value).inject(:+)
        when 1
            @sub_packets.map(&:value).inject(:*)
        when 2
            @sub_packets.map(&:value).min
        when 3
            @sub_packets.map(&:value).max
        when 5
            @sub_packets.map(&:value).inject(:>) ? 1 : 0
        when 6
            @sub_packets.map(&:value).inject(:<) ? 1 : 0
        when 7
            @sub_packets.map(&:value).inject(:==) ? 1 : 0
        else
            raise 'wtf'
        end
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

    def value
        @payload
    end

    def to_s
        "literal packet -> version (#{@version}) : type (#{@type}) : payload (#{@payload})"
    end
end

main
