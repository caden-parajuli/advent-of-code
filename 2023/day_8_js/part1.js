const FILENAME_1 = "input"
const OUTPUT_ID_1 = "part_1_output"

/**
 * @param {string} filename
 * @returns {Promise<string[]>}
 */
async function read_input_1(filename) {
    return fetch(`/${filename}`)
        .then(response => response.text())
        .then(data => data.split(/\r?\n/));
}

/**
 * @param {string[]} lines 
 * @returns {Promise<number>}
 */
async function get_moves_1(lines) {
    let instructions = lines[0];
    var line = find_line_1(lines, "AAA");
    var move = 0;

    while (true) {
        let instruction = instructions[move % instructions.length];
        let pos = get_next_pos_1(line, instruction);
        ++move;
        if (pos == "ZZZ") {
            break;
        }
        line = find_line_1(lines, pos);
    }
    return move;
}

/**
 * @param {string[]} lines 
 * @param {string} pos
 * @returns {string}
 */
function find_line_1(lines, pos) {
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
 * @param {string} line
 * @param {string} instruction 
 * @returns {string}
 */
function get_next_pos_1(line, instruction) {
    if (instruction[0] == "L") {
        return line.substring(7, 10);
    } else if (instruction[0] == "R") {
        return line.substring(12, 15);
    } else {
        console.log(`Error: bad instruction "${instruction[0]}"`);
        return "";
    }
}

async function main_1() {
    let output = document.getElementById(OUTPUT_ID_1);
    output.innerHTML = "Loading...";
    let moves = await read_input_1(FILENAME_1).then((lines) => { return get_moves_1(lines); });
    output.innerHTML = `Final total: ${moves}`
}

main_1()
