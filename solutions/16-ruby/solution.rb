$start = 0

Packet = Struct.new(:version, :typeId, :value, :subPackets) do
  def isLiteral
    typeId == 4
  end
end

def extract_packet(raw)
  version = (raw[($start)...($start+3)]).to_i(2)
  typeId = (raw[($start+3)...($start+6)]).to_i(2)
  if typeId == 4
    # Literal
    res = ""
    size = 6
    idx = ($start+6)
    while raw[idx] != "0"
      newIdx = idx + 5
      res += raw[(idx + 1)...newIdx]
      idx = newIdx
      size += 5
    end
    res += raw[(idx + 1)...(idx + 5)]
    size += 5
    $start += size
    Packet.new(version, typeId, res.to_i(2), nil)
  else
    # Operator
    idx = ($start+6)
    lengthTypeId = raw[idx]
    if lengthTypeId == "0"
      $start = (idx + 16)
      subPacketLen = (raw[(idx+1)...(idx + 16)]).to_i(2)
      subPacketMaxIdx = $start + subPacketLen
      subPackets = []
      while $start < subPacketMaxIdx
        tempPacket = extract_packet(raw)
        subPackets.push(tempPacket)
      end
      Packet.new(version, typeId, 0, subPackets)
    elsif lengthTypeId == "1"
      $start = (idx + 12)
      subPacketLen = (raw[(idx+1)...(idx + 12)]).to_i(2)
      subPackets = []
      i = 0
      while i < subPacketLen
        tempPacket = extract_packet(raw)
        subPackets.push(tempPacket)
        i += 1
      end
      Packet.new(version, typeId, 0, subPackets)
    else
      puts "UNREACHABLE"
    end
  end
end

def part_one(packet)
  res = packet.version 
  if packet.subPackets
    packet.subPackets.reduce(res) { |acc, p| acc + part_one(p) }
  else
    res
  end
end

def part_two(packet)
  case packet.typeId
  when 0
    packet.subPackets.reduce(0) { |acc, p| acc + part_two(p) }
  when 1
    packet.subPackets.reduce(1) { |acc, p| acc * part_two(p) }
  when 2
    (packet.subPackets.map { |p| part_two(p) }).min
  when 3
    (packet.subPackets.map { |p| part_two(p) }).max
  when 4
    packet.value
  when 5
    ((packet.subPackets.map { |p| part_two(p) }).each_cons(2).all? { |a, b| a > b }) ? 1 : 0 
  when 6
    ((packet.subPackets.map { |p| part_two(p) }).each_cons(2).all? { |a, b| a < b }) ? 1 : 0
  when 7
    val = part_two(packet.subPackets[0])
    packet.subPackets.any? { |p| val != part_two(p) } ? 0 : 1
  end
end

def main()
  # test1 = "D2FE28"
  # test2 = "38006F45291200"
  # test3 = "EE00D40C823060"
  # test4 = "8A004A801A8002F478"
  # test5 = "620080001611562C8802118E34"
  # test6 = "C0015000016115A2E0802F182340"
  # test7 = "A0016C880162017C3686B18A3D4780"
  # test8 = "C200B40A82"
  # test9 = "04005AC33890"
  # test10 = "880086C3E88112"
  # test11 = "CE00C43D881120"
  # test12 = "D8005AC2A8F0"
  # test13 = "F600BC2D8F"
  # test14 = "9C005AC2F8F0"
  # test15 = "9C0141080250320F1802104A08"

  inpData = "220D62004EF14266BBC5AB7A824C9C1802B360760094CE7601339D8347E20020264D0804CA95C33E006EA00085C678F31B80010B88319E1A1802D8010D4BC268927FF5EFE7B9C94D0C80281A00552549A7F12239C0892A04C99E1803D280F3819284A801B4CCDDAE6754FC6A7D2F89538510265A3097BDF0530057401394AEA2E33EC127EC3010060529A18B00467B7ABEE992B8DD2BA8D292537006276376799BCFBA4793CFF379D75CA1AA001B11DE6428402693BEBF3CC94A314A73B084A21739B98000010338D0A004CF4DCA4DEC80488F004C0010A83D1D2278803D1722F45F94F9F98029371ED7CFDE0084953B0AD7C633D2FF070C013B004663DA857C4523384F9F5F9495C280050B300660DC3B87040084C2088311C8010C84F1621F080513AC910676A651664698DF62EA401934B0E6003E3396B5BBCCC9921C18034200FC608E9094401C8891A234080330EE31C643004380296998F2DECA6CCC796F65224B5EBBD0003EF3D05A92CE6B1B2B18023E00BCABB4DA84BCC0480302D0056465612919584662F46F3004B401600042E1044D89C200CC4E8B916610B80252B6C2FCCE608860144E99CD244F3C44C983820040E59E654FA6A59A8498025234A471ED629B31D004A4792B54767EBDCD2272A014CC525D21835279FAD49934EDD45802F294ECDAE4BB586207D2C510C8802AC958DA84B400804E314E31080352AA938F13F24E9A8089804B24B53C872E0D24A92D7E0E2019C68061A901706A00720148C404CA08018A0051801000399B00D02A004000A8C402482801E200530058AC010BA8018C00694D4FA2640243CEA7D8028000844648D91A4001088950462BC2E600216607480522B00540010C84914E1E0002111F21143B9BFD6D9513005A4F9FC60AB40109CBB34E5D89C02C82F34413D59EA57279A42958B51006A13E8F60094EF81E66D0E737AE08"

  binary = inpData.split("").reduce("") { |acc, chr|  acc + chr.to_i(16).to_s(2).rjust(4, "0") }
  
  packetStructMap = extract_packet(binary)
  
  puts "Part 1: ", part_one(packetStructMap)
  
  puts "Part 2: ", part_two(packetStructMap)

end

main
