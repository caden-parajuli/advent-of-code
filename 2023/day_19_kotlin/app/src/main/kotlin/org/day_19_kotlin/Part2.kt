package org.day_19_kotlin

import java.math.BigInteger

// Right end open
class Range(var xrange: Pair<Int, Int> = Pair(1, 4001),
            var mrange: Pair<Int, Int> = Pair(1, 4001),
            var arange: Pair<Int, Int> = Pair(1, 4001),
            var srange: Pair<Int, Int> = Pair(1, 4001)) {

    fun copy(): Range {
        return Range(this.xrange.copy(), this.mrange.copy(), this.arange.copy(), this.srange.copy())
    }

    override fun toString(): String {
        return ("{\n\tx: " + this.xrange.toString() + "\n\tm: " + this.mrange.toString() + "\n\ta: " + this.arange.toString() + "\n\ts: " + this.srange.toString() + "\n}")
    }

    fun update(letter: Char, pair: Pair<Int, Int>) {
        when (letter) {
            'x' -> { this.xrange = pair }
            'm' -> { this.mrange = pair }
            'a' -> { this.arange = pair }
            's' -> { this.srange = pair }
        }
    }

    fun combos(): BigInteger {
        return ((this.xrange.second - this.xrange.first).toBigInteger() *
                (this.mrange.second - this.mrange.first).toBigInteger() *
                (this.arange.second - this.arange.first).toBigInteger() *
                (this.srange.second - this.srange.first).toBigInteger())
    }
}

class Flow {
    var name: String = ""
    var conditions: MutableList<Cond> = mutableListOf()
    var last_resort: String = ""

    constructor(work_str: String) {
        val brace_pos = work_str.indexOf('{')
        this.name = work_str.substring(0, brace_pos)

        var trunc_str = work_str.substring(brace_pos + 1)
        var comma_pos = trunc_str.indexOf(',')
        while (comma_pos != -1) {
            conditions.add(Cond(trunc_str.substring(0, comma_pos)))
            trunc_str = trunc_str.substring(comma_pos + 1)
            comma_pos = trunc_str.indexOf(',')
        }
        last_resort = trunc_str.substring(0, trunc_str.length - 1)
    }

    override fun toString(): String {
        return (name + "{" + conditions.map({ x -> x.toString() }).joinToString(",") + "," + last_resort + "}")
    }

    fun split_range(range: Range): List<Pair<String, Range>> {
        return buildList() {
            var i = 0
            var passed_range: Range? = range
            while (i < conditions.size && passed_range != null) {
                val cond = conditions[i]
                val pair = cond.split_range(passed_range)
                if (pair.first != null) {
                    add(Pair(cond.next_flow, pair.first!!))
                }
                passed_range = pair.second
                ++i
            }
            if (passed_range != null) {
                add(Pair(last_resort, passed_range))
            }
        }
    }
}

class Cond {
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

    /// Returns a Pair(accepted, rejected)
    fun split_range(range: Range): Pair<Range?, Range?> {
        // Oh how I miss pointers
        val r = when (this.letter) {
            'x' -> range.xrange
            'm' -> range.mrange
            'a' -> range.arange
            's' -> range.srange
            else -> throw IllegalArgumentException("Bad character in Condition")
        }

        if (this.is_less) {
            if (r.second <= this.number) {
                return Pair(range, null)
            } else if (r.first >= this.number){ 
                return Pair(null, range)
            } else if (r.second > this.number && r.first < this.number) {
                val accept = range.copy()
                accept.update(this.letter, Pair(r.first, this.number))

                val reject = range.copy()
                reject.update(this.letter, Pair(this.number, r.second))

                return Pair(accept, reject)
            } else {
                throw IllegalArgumentException("Bad case in less case")
            }

        } else {
            if (r.first > this.number) {
                return Pair(range, null)
            } else if (r.second <= this.number + 1) {
                return Pair(null, range)
            } else if (r.first < this.number && r.second > this.number + 1) {
                val accept = range.copy()
                accept.update(this.letter, Pair(this.number + 1, r.second))

                val reject = range.copy()
                reject.update(this.letter, Pair(r.first, this.number + 1))

                return Pair(accept, reject)
            } else {
                throw IllegalArgumentException("Bad case in greater case")
            }
        }
    }
}


class Part2 {
    constructor(input: List<String>) {
        val empty_index = input.indexOf("")
        val workflow_strs = input.subList(0, empty_index)

        val ranges = mutableListOf(Pair("in", Range()))
        val workflows = buildMap {
            for (workflow_str: String in workflow_strs) {
                val workflow = Flow(workflow_str)
                put(workflow.name, workflow)
            }
        }

        var total = 0.toBigInteger()
        while (ranges.isNotEmpty()) {
            val ranges_iter: MutableListIterator<Pair<String, Range>> = ranges.listIterator()
            while (ranges_iter.hasNext()) {
                val range = ranges_iter.next()

                if (range.first == "A") {
                    total += range.second.combos()
                    ranges_iter.remove()
                    continue
                } else if (range.first == "R") {
                    ranges_iter.remove()
                    continue
                }

                val flow = workflows.get(range.first)!!
                val new_ranges = flow.split_range(range.second)
                ranges_iter.remove()
                new_ranges.forEach { ranges_iter.add(it) }
            }
        }
        println("Part 2 final total: " + total.toString())
    }
}

