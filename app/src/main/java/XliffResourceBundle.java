import java.util.ListResourceBundle;
import java.util.Locale;

public class XliffResourceBundle extends ListResourceBundle {
    public XliffResourceBundle(String baseName, Locale locale) {
        // TODO
        System.out.println(baseName + " " + locale.toString());
    }

    protected Object[][] getContents() {
        return new Object[][] {
            {"title", "My cool title"},
        };
    }
}
