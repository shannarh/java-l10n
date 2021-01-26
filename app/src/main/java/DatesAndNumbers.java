import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import javafx.scene.control.TextFormatter;

import java.io.IOException;

public class DatesAndNumbers extends SceneController {
    public TextField dividend;
    public TextField divisor;

    @FXML
    public void initialize() {
        restrictToIntegers(dividend);
        restrictToIntegers(divisor);
    }

    public void goBack() throws IOException {
        appController.goToHome();
    }

    private void restrictToIntegers(TextField textField) {
        textField.setTextFormatter(new TextFormatter<>(change -> {
            String changeText = change.getText();
            if (changeText.matches("\\d*")) {
                return change;
            }
            return null;
        }));
    }
}
