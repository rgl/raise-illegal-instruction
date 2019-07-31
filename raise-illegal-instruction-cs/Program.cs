using System.Runtime.InteropServices;

public class Program
{
    public static void Main(string[] args)
    {
        RaiseIllegalInstruction();
    }

    [DllImport("raise-illegal-instruction", EntryPoint = "raise_illegal_instruction")]
    private static extern void RaiseIllegalInstruction();
}
