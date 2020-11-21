import javafx.beans.binding.Bindings;
import javafx.fxml.FXML;
import javafx.scene.control.*;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.ResourceBundle;

public class Home {
    public TextField fullNameTextField;
    public Slider numberOfApples;
    public Label numberOfApplesLabel;
    ResourceBundle messages = ResourceBundle.getBundle("home", Locale.getDefault());

    @FXML
    public void initialize() {
        MessageFormat applesFormatter = new MessageFormat(messages.getString("youHaveXApples"));
        numberOfApplesLabel.textProperty()
            .bind(Bindings.createStringBinding(
                () -> applesFormatter.format(new Object[]{
                    Math.round(numberOfApples.getValue())
                }), numberOfApples.valueProperty()));
    }

    public void sayHello() {
        String greeting = MessageFormat.format(messages.getString("greeting"), fullNameTextField.getText());
        new Alert(Alert.AlertType.NONE, greeting, ButtonType.OK).show();
    }
}
