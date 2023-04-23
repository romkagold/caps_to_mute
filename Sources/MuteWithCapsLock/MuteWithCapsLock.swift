@main
public struct MuteWithCapsLock {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(MuteWithCapsLock().text)
    }
}
