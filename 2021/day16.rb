# --- Day 16: Packet Decoder ---
# https://adventofcode.com/2021/day/16

class PacketDecoder
  def initialize = @packet = ::File.read("./inputs/input16.txt").hex.to_s(2)
  def part1 = PacketDecoder.build(@packet).first.version_sum
  def part2 = PacketDecoder.build(@packet).first.value
  def self.build(packet) = packet[3..5].to_i(2) == 4 ? Literal.build(packet) : Operator.build(packet)

  Operator = Struct.new(:version, :type, :parts, :length_type_id) do
    def version_sum = version.to_i(2) + parts.map(&:version_sum).sum

    def value
      values = parts.map(&:value)
      case type.to_i(2)
      when 0
        values.sum
      when 1
        values.reduce(&:*)
      when 2
        values.min
      when 3
        values.max
      when 5
        first, second = values
        first > second ? 1 : 0
      when 6
        first, second = values
        first < second ? 1 : 0
      when 7
        first, second = values
        first == second ? 1 : 0
      end
    end

    def self.build(packet)
      version, type, length_type_id, rest = packet[0..2], packet[3..5], packet[6], packet[7..-1]
      parts, rest = extract_parts(length_type_id, rest)
      return self.new(version, type, parts, length_type_id), rest
    end

    def self.extract_parts(length_type_id, packet)
      bits = packet.chars
      if length_type_id == "0"
        parts = []
        subpacket_length = bits.shift(15).join.to_i(2)
        subpacket = bits.shift(subpacket_length).join
        while subpacket.length > 0 do
          part, subpacket = PacketDecoder.build(subpacket)
          parts << part
        end
        return parts, bits.join
      elsif length_type_id == "1"
        parts = []
        parts_length = bits.shift(11).join.to_i(2)
        subpacket = bits.join
        parts_length.times do
          part, subpacket = PacketDecoder.build(subpacket)
          parts << part
        end
        return parts, subpacket
      end
    end
  end

  Literal = Struct.new(:version, :type, :value) do
    def version_sum = version.to_i(2)

    def self.build(packet)
      version, type, rest = packet[0..2], packet[3..5], packet[6..-1]
      parts, rest = literal_value_packets(rest)
      return self.new(version, type, parts.map { |p| p[1..-1] }.join.to_i(2) ), rest
    end

    def self.literal_value_packets(packet)
      packets = []
      packet.chars.each_slice(5) do |slice|
        packets << slice.join
        break if slice[0] == "0"
      end
      return packets, packet[packets.length * 5..-1]
    end
  end
end

decoder = PacketDecoder.new
puts decoder.part1
puts decoder.part2
