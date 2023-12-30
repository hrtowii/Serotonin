import SwiftUI
struct ContentView: View {
    @State private var pid: Int32 = 0
    @State private var stringy: String = ""
    var body: some View {
        HStack {
            Button("kfdgo") {
                do_kopen(2048, 1, 2, 2)
//                do_fun()
//                fuck2()
                do_kclose()
            }
            Button("go") {
                fuck()
//                copyLaunchd()
//                userspaceReboot()
            }
            Button("ptracer") {
                ptraceTest()
//                copyLaunchd()
//                userspaceReboot()
            }
            Button("uspreboot") {
//                fuck()
//                copyLaunchd()
                userspaceReboot()
            }
            TextField(
                    "pid",
                    text: $stringy
                )
//                .focused($emailFieldIsFocused)
                .onSubmit {
                    opainject(pid, "test")
                }
        }
    }
}

//#Preview {
//    ContentView()
//}
