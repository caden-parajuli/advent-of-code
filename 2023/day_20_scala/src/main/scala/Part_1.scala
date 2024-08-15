package part_1

import scala.collection.mutable
import scala.collection.mutable.Queue
import scala.io.Source
import java.util.HashMap

case class Signal(source: Module, dest: Module, value: Boolean)
case class Total(low: Int, high: Int)

trait Module {
  var inputs: List[Module]
  var outputs: Array[Module]
  def process(signal: Signal, queue: Queue[Signal]): Unit
  def addInput(input: Module): Unit =
    inputs = input :: inputs
}

class Broadcaster extends Module {
  var inputs = Nil
  var outputs = Array()
  override def process(signal: Signal, queue: Queue[Signal]) =
    outputs.foreach((output: Module) =>
      queue.enqueue(Signal(this, output, signal.value))
    )

}

class FlipFlop extends Module {
  var inputs = Nil
  var outputs = Array()
  var state = false
  override def process(signal: Signal, queue: Queue[Signal]): Unit = {
    if !signal.value then
      state = !state
      outputs.foreach((output: Module) =>
        queue.enqueue(Signal(this, output, state))
      )
  }
}

class Conjunction extends Module {
  var inputs = Nil
  var outputs = Array()
  var inputVals: mutable.Map[Module, Boolean] = mutable.Map[Module, Boolean]()
  override def process(signal: Signal, queue: mutable.Queue[Signal]) = {
    // Update input based on signal
    inputVals += (signal.source -> signal.value)
    // Get the signal output
    var out = false
    inputs.foreach((input: Module) =>
      if !inputVals.apply(input)
      then out = true
    )
    // Broadcast output
    outputs.foreach((output: Module) =>
      queue.enqueue(Signal(this, output, out))
    )
  }

  override def addInput(input: Module): Unit = {
    inputs = input :: inputs
    inputVals += (input, false)
  }
}

class BlankMod extends Module {
  var inputs = Nil
  var outputs = Array()
  override def process(signal: Signal, queue: mutable.Queue[Signal]): Unit = {}
}

def processLine(line: String): (String, Module, Array[String]) = {
  val splitLine = line.split(" -> ")
  val qualName = splitLine(0)
  val outputNames = splitLine(1).split(", ")
  if qualName == "broadcaster" then
    return (qualName, Broadcaster(), outputNames)
  else if qualName(0) == '%' then
    return (qualName.slice(1, qualName.size), FlipFlop(), outputNames)
  else if qualName(0) == '&' then
    return (qualName.slice(1, qualName.size), Conjunction(), outputNames)
  else assert(false)
}

def pushButton(button: BlankMod, broadcaster: Module): (Int, Int) =
  var queue = Queue[Signal](Signal(button, broadcaster, false))
  var low = 0
  var high = 0
  while !queue.isEmpty do
    val signal = queue.dequeue()
    // Update total
    if signal.value then high += 1
    else low += 1
    // process the signal
    signal.dest.process(signal, queue)
  (low, high)

def main(): Unit =
  val filename = "input"
  val lines = Source.fromFile(filename).getLines
  var broadcasterOpt: Option[Module] = None
  var modules = mutable.Map[String, (Module, Array[String])]()
  // Build the map
  for (line <- lines) {
    val (name, module, outputs) = processLine(line)
    modules += (name, (module, outputs))
    if name == "broadcaster" then broadcasterOpt = Some(module)
  }
  // Update inputs and outputs
  for ((name, (module, outputs)) <- modules) {
    module.outputs = outputs.map { (output: String) =>
      modules.get(output) match {
        case Some((outMod, _)) =>
          outMod.addInput(module)
          outMod
        case None => BlankMod()
      }
    }
  }
  // Do the actual work
  val button = BlankMod()
  val broadcaster = broadcasterOpt match {
    case None        => assert(false)
    case Some(broad) => broad
  }
  button.outputs = Array(broadcaster)
  var low: Int = 0
  var high: Int = 0
  (1 to 1000).foreach { (i: Int) =>
    val (roundLow, roundHigh) = pushButton(button, broadcaster)
    low += roundLow
    high += roundHigh
  }
  print("Part 1 final total: ")
  println(low * high)
