/*
 * This source file was generated by the Gradle 'init' task
 */
package org.day_19_kotlin

import java.io.File

const val filename = "../input"

class Main {}

fun main() {
    val input = File(filename).readLines()
    Part1(input)
    Part2(input)
}
