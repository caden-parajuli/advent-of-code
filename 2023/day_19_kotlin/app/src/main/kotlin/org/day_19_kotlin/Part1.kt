package org.day_19_kotlin

class Part {
    public var x: Int = 0
    public var m: Int = 0
    public var a: Int = 0
    public var s: Int = 0
    constructor(part_str: String) {
        var temp_str = part_str
        var equal_pos = temp_str.indexOf('=')
        var comma_pos = temp_str.indexOf(',')
        this.x = temp_str.substring(equal_pos + 1, comma_pos).toInt()

        temp_str = temp_str.substring(comma_pos + 1)
        equal_pos = temp_str.indexOf('=')
        comma_pos = temp_str.indexOf(',')
        this.m = temp_str.substring(equal_pos + 1, comma_pos).toInt()

        temp_str = temp_str.substring(comma_pos + 1)
        equal_pos = temp_str.indexOf('=')
        comma_pos = temp_str.indexOf(',')
        this.a = temp_str.substring(equal_pos + 1, comma_pos).toInt()

        temp_str = temp_str.substring(comma_pos + 1)
        equal_pos = temp_str.indexOf('=')
        comma_pos = temp_str.indexOf('}')
        this.s = temp_str.substring(equal_pos + 1, comma_pos).toInt()

    }

    override fun toString(): String {
        return ("{x=" + x.toString() + ",m=" + m.toString() + ",a=" + a.toString() + ",s=" + s.toString() + "}")
    }
}


class Workflow {
    var name: String = ""
    var conditions: MutableList<Condition> = mutableListOf()
    var last_resort: String = ""

    constructor(work_str: String) {
        val brace_pos = work_str.indexOf('{')
        this.name = work_str.substring(0, brace_pos)

        var trunc_str = work_str.substring(brace_pos + 1)
        var comma_pos = trunc_str.indexOf(',')
        while (comma_pos != -1) {
            conditions.add(Condition(trunc_str.substring(0, comma_pos)))
            trunc_str = trunc_str.substring(comma_pos + 1)
            comma_pos = trunc_str.indexOf(',')
        }
        last_resort = trunc_str.substring(0, trunc_str.length - 1)
    }

    override fun toString(): String {
        return (name + "{" + conditions.map({ x -> x.toString() }).joinToString(",") + "," + last_resort + "}")
    }

    fun to_next_flow(part: Part): String {
        for (cond: Condition in conditions) {
            val flow = cond.to_next_flow(part)
            if (flow != null) {
                return flow!!
            }
        }
        return this.last_resort
    }
}

class Condition {
    var letter: Char = '0'
    var is_less: Boolean = true
    var number: Int
    var next_flow: String

    constructor(cond_str: String) {
        val colon_index = cond_str.indexOf(':')
        this.letter = cond_str[0]
        this.is_less = cond_str[1] == '<'
        this.number = cond_str.substring(2, colon_index).toInt()
        this.next_flow = cond_str.substring(colon_index + 1)
    }

    override fun toString(): String {
        return (letter.toString() + (if (is_less) "<" else ">") + number.toString() + next_flow)
    }

    fun to_next_flow(part: Part): String? {
        val letter_val = when (this.letter) {
            'x' -> part.x
            'm' -> part.m
            'a' -> part.a
            's' -> part.s
            else -> throw IllegalArgumentException("Bad character in Condition")
        }
        return if (this.is_less) {
            if (letter_val < this.number) { next_flow } else { null }
        } else {
            if (letter_val > this.number) { next_flow } else { null }
        }
    }
}

class Part1 {
    constructor(input: List<String>) {
        val empty_index = input.indexOf("")
        val workflow_strs = input.subList(0, empty_index)
        val part_strs = input.subList(empty_index + 1, input.lastIndex + 1)

        val parts = part_strs.map({ Pair("in", Part(it)) }).toMutableList()
        val workflows = buildMap {
            for (workflow_str: String in workflow_strs) {
                val workflow = Workflow(workflow_str)
                put(workflow.name, workflow)
            }
        }

        var total = 0
        while (parts.isNotEmpty()) {
            val parts_iter: MutableListIterator<Pair<String, Part>> = parts.listIterator()
            while (parts_iter.hasNext()) {
                val part = parts_iter.next()!!
                val flow = workflows.get(part.first)!!
                val next_flow = flow.to_next_flow(part.second)!!
                if (next_flow == "A") {
                    total += part.second.x + part.second.m + part.second.a + part.second.s
                    parts_iter.remove()
                } else if (next_flow == "R") {
                    parts_iter.remove()
                } else {
                    parts_iter.set(Pair(next_flow, part.second))
                }

            }
        }
        println("Part 1 final total: " + total.toString())
    }
}


