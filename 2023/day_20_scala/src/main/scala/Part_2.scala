package part_2

import scala.collection.mutable
import scala.collection.mutable.Queue
import scala.io.Source
import java.util.HashMap

case class Ref[A](var value: A)
case class Signal(source: Module, dest: Module, value: Boolean)
case class Total(low: Int, high: Int)

trait Module {
  val kind: Int
  val name: String
  var gotHigh: Boolean = false
  var inputs: List[Module]
  var outputs: Array[Module]
  def process(signal: Signal, queue: Queue[Signal]): Unit
  def addInput(input: Module): Unit =
    inputs = input :: inputs
}

class Broadcaster(n: String) extends Module {
  val kind = 0
  val name = n
  var inputs = Nil
  var outputs = Array()
  override def process(signal: Signal, queue: Queue[Signal]) =
    outputs.foreach((output: Module) =>
      queue.enqueue(Signal(this, output, signal.value))
    )
}

class FlipFlop(n: String) extends Module {
  val kind = 1
  val name = n
  var inputs = Nil
  var outputs = Array()
  var state = false
  override def process(signal: Signal, queue: Queue[Signal]): Unit = {
    if !signal.value then
      state = !state
      outputs.foreach((output: Module) =>
        queue.enqueue(Signal(this, output, state))
      )
      gotHigh = state
  }
}

class Conjunction(n: String) extends Module {
  val kind = 2
  val name = n
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
    gotHigh = gotHigh || out
  }

  override def addInput(input: Module): Unit = {
    inputs = input :: inputs
    inputVals += (input, false)
  }
}

class BlankMod(n: String) extends Module {
  val kind = 3
  val name = n
  var inputs = Nil
  var outputs = Array()
  override def process(signal: Signal, queue: mutable.Queue[Signal]): Unit = {}
}

def processLine(line: String): (String, Module, Array[String]) = {
  val splitLine = line.split(" -> ")
  val qualName = splitLine(0)
  val outputNames = splitLine(1).split(", ")
  if qualName == "broadcaster" then
    return (qualName, Broadcaster(qualName), outputNames)
  else if qualName(0) == '%' then
    val name = qualName.slice(1, qualName.size)
    return (name, FlipFlop(name), outputNames)
  else if qualName(0) == '&' then
    val name = qualName.slice(1, qualName.size)
    return (name, Conjunction(name), outputNames)
  else assert(false)
}

def pushButton(button: BlankMod, broadcaster: Module) =
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

def main(): Unit =
  val filename = "input"
  val lines = Source.fromFile(filename).getLines
  var broadcasterOpt: Option[Module] = None
  var moverOpt: Option[BlankMod] = None
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
        case None =>
          if output == "rx" then {
            val mover = BlankMod(output)
            mover.addInput(module)
            moverOpt = Some(mover)
            mover
          } else assert(false)
      }
    }
  }
  // Do the actual work
  val button = BlankMod("button")
  val broadcaster = broadcasterOpt match {
    case None        => assert(false)
    case Some(broad) => broad
  }
  button.outputs = Array(broadcaster)

  val mover = moverOpt match {
    case None     => assert(false)
    case Some(rx) => rx
  }
  assert(mover.inputs.size == 1) // There should only be one input to the mover
  assert(mover.inputs(0).kind == 2) // moverMover should be a conjunction

  var submovers = mover.inputs(0).inputs.map((_, Ref(false)))

  var finalPresses: BigInt = 1
  var countedPresses: BigInt = 0
  var done = false

  while !done do
    pushButton(button, broadcaster)
    countedPresses += 1

    done = true
    for (submover <- submovers) {
      if !submover._2.value && submover._1.gotHigh then
        submover._2.value = true
        finalPresses =
          finalPresses * countedPresses / finalPresses.gcd(countedPresses)

      if !submover._2.value then done = false
    }

  print("Part 2 final total: ")
  println(finalPresses)
