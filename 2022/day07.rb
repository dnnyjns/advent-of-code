# --- Day 7: No Space Left On Device ---
# https://adventofcode.com/2022/day/7

class NoSpaceLeftOnDevice
  AocFile = Struct.new(:name, :size) do
    def to_s
      "FILE: #{name} - #{size}"
    end
  end

  class Directory
    include Enumerable

    attr_reader :name, :children, :parent

    def initialize(name, parent = nil)
      @name = name
      @parent = parent
      @children ||= []
    end

    def each(&block)
      @children.each do |child|
        next unless child.is_a?(Directory)
        block.call(child)
        child.each do |c|
          block.call(c)
        end
      end
    end

    def cd(directory_name)
      dir = Directory.new(directory_name, self)
      add(dir)

      @children.detect { |c| c == dir }
    end

    def add(child)
      @children << child unless @children.include?(child)
    end

    def ==(other)
      other.class == self.class && other.name == self.name
    end

    def size
      children.sum(&:size)
    end

    def tabs
      1 + parent&.tabs.to_i
    end

    def to_s
      str = "DIRECTORY - #{name} - #{size}"
      @children.each do |child|
        str += "\n" + ("\t" * tabs) + child.to_s
      end
      str
    end
  end

  def self.tree
    curr = root = Directory.new("/")

    ::File.foreach("./inputs/input07.txt") do |line|
      if line.start_with?("$")
        _, cmd, dir = line.split(" ")
        case cmd
        when "cd"
          case dir
          when "/"
            curr = root
          when ".."
            curr = curr.parent
          else
            curr = curr.cd(dir)
          end
        else
          next
        end
      elsif line.start_with?("dir")
        next
      else
        size, name = line.split(" ")
        curr.add(AocFile.new(name, size.to_i))
      end
    end

    root
  end

  def self.part1
    tree.select { |directory| directory.size <= 100_000 }.sum(&:size)
  end

  def self.part2
    root = tree
    disk_size = 70_000_000
    root_size = root.size
    target_size = 30_000_000 - (disk_size - root_size)

    root.select { |directory| directory.size >= target_size }.map(&:size).min
  end
end

puts NoSpaceLeftOnDevice.part1
puts NoSpaceLeftOnDevice.part2
