#https://gist.github.com/telent/2500413

require 'pp'
require 'socket'
 
module BluetoothPolarHrm
  AF_BLUETOOTH=31               # these are correct for the Linux Bluez stack
  BTPROTO_RFCOMM=3
  class << self
    def connect_bt address_str,channel=1
    bytes=address_str.split(/:/).map {|x| x.to_i(16) }
    s=Socket.new(AF_BLUETOOTH, :STREAM, BTPROTO_RFCOMM)
    sockaddr=[AF_BLUETOOTH,0, *bytes.reverse, channel,0 ].pack("C*")
    s.connect(sockaddr)
    s
  rescue => e
    $stderr.print "bluetooth failed to connect: " + e.message + "\n"
  end

  def decode bytes
    # http://code.google.com/p/mytracks/source/browse/MyTracks/src/com/google/android/apps/mytracks/services/sensors/PolarMessageParser.java
    start=bytes.index(0xfe.chr)
    unless start then
      warn "bad message #{bytes.inspect}"
      return [nil,bytes]
    end
    start.zero? or bytes=bytes.slice(start..-1)
    if (bytes.length < 2) || (bytes[1].ord > bytes.length)
      return [nil,bytes]
    end
    ret={
      len: bytes[1].ord,
      chk: bytes[2].ord,
      seq: bytes[3].ord,
      status: bytes[4].ord,
      hr: bytes[5].ord,
    rr: [(bytes[6].ord << 8) | bytes[7].ord]
    }
    if ret[:chk]+ret[:len] != 255 then
      warn "bad message #{bytes.inspect}"
      return [nil,bytes]
    end
      
    [ret,bytes.slice(ret[:len]..-1)]
  end
 
  def connect(address)
    Enumerator.new do |y|
      pin=connect_bt(address)
      buf=''
      while(true) do
        buf+=pin.recv(80)
        data,buf=decode(buf)
        if data 
          row=data.merge({time: Time.now})
          y << row
        end
      end
    end
  rescue => e
    $stderr.print e.message + "\n"

  end
  end
rescue => e
  $stderr.print e.message + "\n"

end
 
# connect should be called with a bluetooth address (e.g. "00:22:D0:01:ED:3B").  You can find this with
# "hcitool scan" or on probably a million  other ways
 
#BluetoothPolarHrm.connect("00:22:D0:01:ED:3B").each do |d|
#  warn d
#end
