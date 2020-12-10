import Foundation
import DirectoryService

struct RowData: Hashable {
	let file: String
	let row: String
	let column: String
	let references: String
	let code: String
}

var data = [RowData : [Int]]()
guard CommandLine.argc != 1 else {
	print("Usage: ./averager [files ...]")
	exit(0)
}

CommandLine.arguments.dropFirst().forEach { arg in
	let url = URL(fileURLWithPath: arg)
	do {
		let csv = try CSV(url: url)
		try csv.enumerateAsDict { dict in
			if
				let file = dict["file"],
				let row = dict["row"],
				let column = dict["column"],
				let references = dict["references"],
				let code = dict["code"],
				let timeString = dict["time"],
				let time = Int(timeString) {
				let rowData = RowData(file: file, row: row, column: column, references: references, code: code)
				if data[rowData] == nil {
					data[rowData] = [time]
				} else {
					data[rowData]?.append(time)
				}
			} else {
				print("Some error in \(url) file")
			}
		}
	} catch {
		print("Can't open file: \(url)")
	}
}

let averageData = data.mapValues { value in
	value.reduce(0, +) / value.count
}

let sortedData = averageData.sorted { (first, second) -> Bool in
	first.value > second.value
}

var csvString: String = "\"time\",\"file\",\"row\",\"column\",\"references\",\"code\"\n"

sortedData.forEach { key, value in
	csvString.append("\"\(value)\",\"\(key.file)\",\"\(key.row)\",\"\(key.column)\",\"\(key.references)\",\"\(key.code)\"\n")
}
let filename = Bundle.main.bundlePath.appending("/Average.csv")
do {
	try csvString.write(toFile: filename, atomically: true, encoding: .utf8)
} catch {
	print("Unable to write \(filename) file")
	exit(1)
}

print("Average file saved in: \(filename)")
