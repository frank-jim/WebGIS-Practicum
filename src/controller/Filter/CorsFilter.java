package controller.Filter;

import java.util.logging.Filter;
import java.util.logging.LogRecord;

public class CorsFilter implements Filter {

    @Override
    public boolean isLoggable(LogRecord record) {
        return false;
    }
}
