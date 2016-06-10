class MidiHandler
{
  MidiHandler()
  {
    MidiDevice device;
    MidiDevice.Info[] infos = MidiSystem.getMidiDeviceInfo();
    for (int i = 0; i < infos.length; i++) {
      try {
        device = MidiSystem.getMidiDevice(infos[i]);
        //does the device have any transmitters?
        //if it does, add it to the device list
        //println(infos[i]); //Print MIDI devices

        //get all transmitters
        List<Transmitter> transmitters = device.getTransmitters();
        //and for each transmitter

        for (int j = 0; j<transmitters.size(); j++) {
          //create a new receiver
          transmitters.get(j).setReceiver(
            //using my own MidiInputReceiver
            new MidiInputReceiver(device.getDeviceInfo().toString())
            );
        }

        Transmitter trans = device.getTransmitter();
        trans.setReceiver(new MidiInputReceiver(device.getDeviceInfo().toString()));

        device.open();                                              //open each device
        //System.out.println(device.getDeviceInfo()+" Was Opened"); //Print succes message
      } 
      catch (MidiUnavailableException e) {
      }
    }
  }
  //tried to write my own class. I thought the send method handles an MidiEvents sent to it
  class MidiInputReceiver implements Receiver {
    public String name;
    public MidiInputReceiver(String name) {
      this.name = name;
    }
    public void send(MidiMessage message, long timeStamp) {
      //println("midi received");
      //println(timeStamp);

      if (message instanceof ShortMessage) {
        ShortMessage sm = (ShortMessage) message;
        //System.out.println("Channel: " + sm.getChannel());
        //System.out.println("key: " + sm.getData1());
        //System.out.println("velocity: " + sm.getData2());
        //System.out.println("Command:" + sm.getCommand());

        if (sm.getCommand()==144) {
          keyz[sm.getData1()-36]=true;
          myBus.sendNoteOn(0, sm.getData1(), sm.getData2()); // Send a Midi noteOn
          for (int i=0; i<MIDIsongs[game.activeSong].MIDINotes.length; i++) {
            if (MIDIsongs[game.activeSong].MIDINotes[i].key==sm.getData1()+12) {
              if (MIDIsongs[game.activeSong].MIDINotes[i].startTick<MIDIsongs[game.activeSong].tick
                &&MIDIsongs[game.activeSong].MIDINotes[i].endTick>MIDIsongs[game.activeSong].tick) {
                MIDIsongs[game.activeSong].MIDINotes[i].hit = true;
              }
            }
          }
        } else if (sm.getCommand()==128) {
          keyz[sm.getData1()-36]=false;
          myBus.sendNoteOff(0, sm.getData1(), sm.getData2()); // Send a Midi noteOff
        }
      }
    }
    public void close() {
    }
  }
}