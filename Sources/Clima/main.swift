import ClimaCore

let tool = Clima()

do{
    try tool.run()
} catch {
    print("Whoops! An error occirred: \(error)")
}
