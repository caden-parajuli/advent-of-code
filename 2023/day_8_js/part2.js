const FILENAME_2 = "input";
const OUTPUT_ID_2 = "part_2_output";
var hashtable = new Map();

/**
 * @param {number} a
 * @param {number} b
 */
function gcd(a, b) {
    return a ? gcd(b % a, a) : b;
}
/**
 * @param {number} a
 * @param {number} b
 */
function lcm(a, b){
    return a * b / gcd(a, b);
}


/**
 * @param {string} filename
 * @returns {Promise<string[]>}
 */
async function read_input(filename) {
    return fetch(`/${filename}`)
        .then(response => response.text())
        .then((data) => {
            let lines = data.split(/\r?\n/);
            return lines;
        });
}


/**
 * @param {string[]} lines 
 * @returns {string[]}
 */
function get_a_lines(lines) {
    var a_lines = [];
    for (let i = 1; i < lines.length; ++i) {
        let line = lines[i];
        if (line[2] == "A") {
            a_lines.push(line);
        }
    }
    return a_lines;
}

/**
 * @param {string[]} lines 
 * @returns {number}
 */
function get_moves(lines) {
    let instructions = lines[0];
    var curr_lines = get_a_lines(lines);
    var periods = [];
    var complete = 0;
    var move = 0;

    while (complete != curr_lines.length) {
        let instruction = instructions[move % instructions.length];
        ++move;
        complete += next_round(curr_lines, instruction, periods, move);
    }
    console.log(`Complete: ${complete}`);
    console.log(periods);
    return periods.reduce(lcm);
}

/**
 * @param {string[]} lines 
 * @param {string} pos
 * @returns {string}
 */
function find_line(lines, pos) {
    for (var index = 1; index < lines.length; ++index) {
        let line = lines[index];
        if (line.substring(0, 3) == pos.substring(0, 3)) {
            return line;
        }
    }
    console.log("Error: position not found");
    return "";
}

/**
 * @param {string[]} curr_lines
 * @param {string} instruction
    * @param {number[]} periods
    * @param {number} [move]
 * @returns {number}
 */
function next_round(curr_lines, instruction, periods, move) {
    var start;
    var end;
    if (instruction[0] == "L") {
        start = 7;
        end = 10;
    } else if (instruction[0] == "R") {
        start = 12;
        end = 15;
    } else {
        console.log(`Error: bad instruction "${instruction[0]}"`);
    }

    var num_done = 0;
    for (let j = 0; j < curr_lines.length; ++j) {
        let new_line = hashtable.get(curr_lines[j].substring(start, end));
        if (new_line && new_line != undefined) {
            curr_lines[j] = new_line;
        } else {
            console.log("Undefined new_line");
        }
        if (curr_lines[j][2] == "Z") {
            periods[j] = move;
            num_done += 1;
        }
    }

    return num_done;
}

async function main() {
    let output = document.getElementById(OUTPUT_ID_2);
    // output.innerHTML = "Loading...";
    let lines = await read_input(FILENAME_2);
    for (let i = 1; i < lines.length; ++i) {
        let line = lines[i]
        if (line.length > 15) {
            hashtable.set(line.substring(0, 3), line);
        }
    }
    let moves = get_moves(lines);
    output.innerHTML = `Final total: ${moves}`
}

main()
