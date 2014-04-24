#!/usr/bin/ruby

require 'storage'

prep_size = 8192
parted = "parted -s -a minimal"

env = Storage::Environment.new(true)
c = Storage::createStorageInterface(env)
containers = Storage::DequeContainerInfo.new()
c.getContainers(containers)

def runlog cmd
  print "Exec: #{cmd}\n"
  `#{cmd}`
end

containers.each do |container|

    if container.type == Storage::DISK then

        diskinfo = Storage::DiskInfo.new()
        c.getDiskInfo(container.name, diskinfo)

        partitioninfos = Storage::DequePartitionInfo.new()
        c.getPartitionInfo(container.name, partitioninfos)

        partitioninfos.each do |partitioninfo|
          size_k = partitioninfo.v.sizeK                  #Partition size in Kb
          device = container.device                       #Parent device
          part_nr = partitioninfo.nr                      #Partition number
          id = partitioninfo.id                           #Partition id
          if ([0x108,0x41].include? id && partitioninfo.boot )
            print "Device: ",  device, "\n"
            print "  Partition Nr: ", part_nr, "\n"
            print "  Size: ", size_k, "K" "\n"
            print "Found PReP partition: ", partitioninfo.v.device, "\n"
              if size_k > prep_size
                runlog "#{parted} #{device} resize #{part_nr} #{prep_size}k"
              else
                print size_k, "k of ", partitioninfo.v.device, " is not bigger than ", prep_size, "k... exiting \n"
              end
          else
            print "nothing to do \n"
          end
        end
    end
end
