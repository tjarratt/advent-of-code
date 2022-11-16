fun main(args: Array<String>) {
    println("Hello World!")

    val masses = readMassesFromInput()
    masses.forEach {
        println("mass to measure for fuel $it")
    }

    println("done")
}

fun readMassesFromInput() : List<Int> {
    val asString = {}::class.java.getResource("input").readText()
    return asString.split("\n").map { it.toInt() }
}