import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;

public class LocalizationApp extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws IOException {
        ResourceBundle messages = ResourceBundle.getBundle("tabContainer", Locale.getDefault());
        Parent root = FXMLLoader.load(getClass().getResource("ui/TabContainer.fxml"), messages);
        primaryStage.setTitle("Java Localization App");
        primaryStage.setScene(new Scene(root));
        primaryStage.show();
    }
}
