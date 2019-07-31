using Xunit;

public class ProgramTests
{
    [Fact]
    public void MainCrashes()
    {
        Program.Main(new string[] {});
        Assert.False(true);
    }
}
