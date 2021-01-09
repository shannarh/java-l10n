import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import net.sf.okapi.common.Event;
import net.sf.okapi.common.EventType;
import net.sf.okapi.common.LocaleId;
import net.sf.okapi.common.filterwriter.GenericContent;
import net.sf.okapi.common.resource.RawDocument;
import net.sf.okapi.common.resource.TextContainer;
import net.sf.okapi.filters.xliff2.XLIFF2Filter;

import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;

public class LocalizationApp extends Application {

    private Stage primaryStage;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        this.primaryStage = primaryStage;

        if (primaryStage.getScene() != null) {
            throw new Exception("Primary stage already has a scene before application start");
        }

        goToHome();
        primaryStage.show();
    }

    public void goToHome() throws IOException {
        ResourceBundle messages = ResourceBundle.getBundle("home", Locale.getDefault());
        FXMLLoader loader = new FXMLLoader(getClass().getResource("ui/Home.fxml"), messages);
        Parent homeView = loader.load();
        Home homeController = loader.getController();
        homeController.setAppController(this);
        primaryStage.setTitle("Home");

        if (primaryStage.getScene() == null) {
            primaryStage.setScene(new Scene(homeView));
        }
        else {
            primaryStage.getScene().setRoot(homeView);
        }
    }

    public void goToDetails() throws IOException {
        ResourceBundle messages = ResourceBundle.getBundle("details", Locale.getDefault());
        FXMLLoader loader = new FXMLLoader(getClass().getResource("ui/Details.fxml"), messages);
        Parent detailsView = loader.load();
        Details detailsController = loader.getController();
        detailsController.setAppController(this);
        primaryStage.setTitle("Details");

        if (primaryStage.getScene() == null) {
            primaryStage.setScene(new Scene(detailsView));
        }
        else {
            primaryStage.getScene().setRoot(detailsView);
        }
    }

    private void xliffTest() {
        try {
            // Create the filter (based on the extension of the input)
            XLIFF2Filter filter = new XLIFF2Filter();
            // Open the document to process
            filter.open(
                new RawDocument(getClass().getResource("details_pt.xlf").toURI(),
                    "UTF-8",
                    LocaleId.ENGLISH,
                    LocaleId.PORTUGUESE));

            // Handles the conversion between a coded text object and a generic markup string?
            GenericContent fmt = new GenericContent();

            System.out.println("Starting...");
            // process the input document
            while (filter.hasNext()) {
                Event event = filter.next();
                if (event.isTextUnit()) {
                    TextContainer target = event.getTextUnit().getTarget(LocaleId.PORTUGUESE);
                    System.out.println(target != null ? target.toString() : "");
                    fmt.setContent(event.getTextUnit().getSource().getFirstContent());
                    System.out.println(fmt.toString());
                }
                else {
                    System.out.println("Other");
                }
            }
            System.out.println("Done");
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
}
