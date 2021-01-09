import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.Locale;
import java.util.ResourceBundle;

public class Details extends SceneController {
    @FXML
    public void initialize() {
    }

    public void goBack() throws IOException {
        appController.goToHome();
    }
}
