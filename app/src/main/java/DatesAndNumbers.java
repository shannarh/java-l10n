import javafx.beans.binding.Bindings;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.control.TextFormatter;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;

public class DatesAndNumbers extends SceneController {
    private static final int MAX_NUMBER_INPUT_LENGTH = 64;

    public TextField dividend;
    public TextField divisor;
    public Label dividendFormatted;
    public Label divisorFormatted;
    public Label outputFormatted;

    @FXML
    public void initialize() {
        restrictToIntegers(dividend);
        restrictToIntegers(divisor);

        NumberFormat numberFormatter = NumberFormat.getInstance();
        dividendFormatted.textProperty()
            .bind(Bindings.createStringBinding(
                () -> dividend.textProperty().isEmpty().get() ?
                    "" :
                    numberFormatter.format(
                        new BigDecimal(dividend.textProperty().get())),
                dividend.textProperty()));
        divisorFormatted.textProperty()
            .bind(Bindings.createStringBinding(
                () -> divisor.textProperty().isEmpty().get() ?
                    "" :
                    numberFormatter.format(
                        new BigDecimal(divisor.textProperty().get())),
                divisor.textProperty()));
        outputFormatted.textProperty()
            .bind(Bindings.createStringBinding(
                () -> {
                    if (dividend.textProperty().isEmpty().get() || divisor.textProperty().isEmpty().get()) {
                        return "";
                    }
                    try {
                        return numberFormatter.format(
                            new BigDecimal(dividend.textProperty().get()).divide(
                                new BigDecimal(divisor.textProperty().get()), 3, RoundingMode.HALF_EVEN));
                    } catch (ArithmeticException e) {
                        System.err.println(e);
                        return "undefined";
                    }
                },
                dividend.textProperty(), divisor.textProperty()));
    }

    public void goBack() throws IOException {
        appController.goToHome();
    }

    private void restrictToIntegers(TextField textField) {
        textField.setTextFormatter(new TextFormatter<>(change -> {
            if (change.isContentChange() && change.getControlNewText().length() <= MAX_NUMBER_INPUT_LENGTH) {
                String changeText = change.getText();
                if (changeText.matches("\\d*")) {
                    return change;
                }
            }
            return null;
        }));
    }
}
