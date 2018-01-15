package cn.edu.hdu.Utils;

import java.util.StringTokenizer;
import org.apache.log4j.Level;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.spi.LoggingEvent;

public class ColoredPatternLayout extends PatternLayout {
	 private static final String CONFIGURATION_SEPARATOR = "/";
	 private static final String PREFIX = "\033[";
	 private static final String SUFFIX = "m";
	 private static final char SEPARATOR = ';';
	 private static final String END_COLOR = "\033[m";
	 private static final String ATTR_NORMAL = "0";
	 private static final String ATTR_BRIGHT = "1";
	 private static final String ATTR_DIM = "2";
	 private static final String ATTR_UNDERLINE = "3";
	 private static final String ATTR_BLINK = "5";
	 private static final String ATTR_REVERSE = "7";
	 private static final String ATTR_HIDDEN = "8";
	 private static final String FG_BLACK = "30";
	 private static final String FG_RED = "31";
	 private static final String FG_GREEN = "32";
	 private static final String FG_YELLOW = "33";
	 private static final String FG_BLUE = "34";
	 private static final String FG_MAGENTA = "35";
	 private static final String FG_CYAN = "36";
	 private static final String FG_WHITE = "37";
	 private static final String BG_BLACK = "40";
	 private static final String BG_RED = "41";
	 private static final String BG_GREEN = "42";
	 private static final String BG_YELLOW = "44";
	 private static final String BG_BLUE = "44";
	 private static final String BG_MAGENTA = "45";
	 private static final String BG_CYAN = "46";
	 private static final String BG_WHITE = "47";
	private String fatalErrorColor = "\033[2;31m";
	private String errorColor = "\033[2;31m";
	private String warnColor = "\033[2;33m";
	private String infoColor = PREFIX+ATTR_NORMAL+";"+BG_WHITE+"m" ;//"\033[2;32m";
	private String debugColor = PREFIX+ATTR_NORMAL+";"+BG_WHITE+"m" ;//"\033[2;34m"

	public ColoredPatternLayout() {
	}

	public ColoredPatternLayout(String pattern) {
		super(pattern);
	}

	public String format(LoggingEvent event) {
		if (event.getLevel() == Level.FATAL) {
			return this.fatalErrorColor + super.format(event) + "\033[m";
		}
		if (event.getLevel().equals(Level.ERROR)) {
			return this.errorColor + super.format(event) + "\033[m";
		}
		if (event.getLevel().equals(Level.WARN)) {
			return this.warnColor + super.format(event) + "\033[m";
		}
		if (event.getLevel().equals(Level.INFO)) {
			return this.infoColor + super.format(event) + "\033[m";
		}
		if (event.getLevel().equals(Level.DEBUG)) {
			return this.debugColor + super.format(event) + "\033[m";
		}
		throw new RuntimeException("Unsupported Level " + event.toString());
	}

	private String makeFgString(String fgColorName) {
		if (fgColorName.toLowerCase().equals("black")) {
			return "30";
		}
		if (fgColorName.toLowerCase().equals("red")) {
			return "31";
		}
		if (fgColorName.toLowerCase().equals("green")) {
			return "32";
		}
		if (fgColorName.toLowerCase().equals("yellow")) {
			return "33";
		}
		if (fgColorName.toLowerCase().equals("blue")) {
			return "34";
		}
		if (fgColorName.toLowerCase().equals("magenta")) {
			return "35";
		}
		if (fgColorName.toLowerCase().equals("cyan")) {
			return "36";
		}
		if (fgColorName.toLowerCase().equals("white")) {
			return "37";
		}
		System.out.println("log4j: ColoredPatternLayout Unsupported FgColor " + fgColorName);
		return "-1";
	}

	private String makeBgString(String bgColorName) {
		if (bgColorName.toLowerCase().equals("black")) {
			return "40";
		}
		if (bgColorName.toLowerCase().equals("red")) {
			return "41";
		}
		if (bgColorName.toLowerCase().equals("green")) {
			return "42";
		}
		if (bgColorName.toLowerCase().equals("yellow")) {
			return "44";
		}
		if (bgColorName.toLowerCase().equals("blue")) {
			return "44";
		}
		if (bgColorName.toLowerCase().equals("magenta")) {
			return "45";
		}
		if (bgColorName.toLowerCase().equals("cyan")) {
			return "46";
		}
		if (bgColorName.toLowerCase().equals("white")) {
			return "47";
		}
		System.out.println("log4j: ColoredPatternLayout Unsupported BgColor " + bgColorName);
		return "-1";
	}

	private String makeAttributeString(String attributeName) {
		if (attributeName.toLowerCase().equals("normal")) {
			return "0";
		}
		if (attributeName.toLowerCase().equals("bright")) {
			return "1";
		}
		if (attributeName.toLowerCase().equals("dim")) {
			return "2";
		}
		if (attributeName.toLowerCase().equals("underline")) {
			return "3";
		}
		if (attributeName.toLowerCase().equals("blink")) {
			return "5";
		}
		if (attributeName.toLowerCase().equals("reverse")) {
			return "7";
		}
		if (attributeName.toLowerCase().equals("hidden")) {
			return "8";
		}
		System.out.println("log4j: ColoredPatternLayout Unsupported Attribute " + attributeName);

		return "-1";
	}

	private String makeColorString(String colorName) {
		StringTokenizer tokenizer = new StringTokenizer(colorName, "/");
		String fgColor = "37";
		String bgColor = "40";
		String attr = "0";
		if (!tokenizer.hasMoreTokens()) {
			return "\033[0;37m";
		}
		if (tokenizer.hasMoreTokens()) {
			fgColor = makeFgString(tokenizer.nextToken());
		}
		if (tokenizer.hasMoreTokens()) {
			bgColor = makeBgString(tokenizer.nextToken());
		}
		if (tokenizer.hasMoreTokens()) {
			attr = makeAttributeString(tokenizer.nextToken());
		}
		return

		"\033[" + attr + ';' + fgColor + ';' + bgColor + "m";
	}

	public String getFatalErrorColor() {
		return this.fatalErrorColor;
	}

	public void setFatalErrorColor(String colorName) {
		this.fatalErrorColor = makeColorString(colorName);
	}

	public String getErrorColor() {
		return this.errorColor;
	}

	public void setErrorColor(String colorName) {
		this.errorColor = makeColorString(colorName);
	}

	public String getWarnColor() {
		return this.warnColor;
	}

	public void setWarnColor(String colorName) {
		this.warnColor = makeColorString(colorName);
	}

	public String getInfoColor() {
		return this.infoColor;
	}

	public void setInfoColor(String colorName) {
		this.infoColor = makeColorString(colorName);
	}

	public String getDebugColor() {
		return this.debugColor;
	}

	public void setDebugColor(String colorName) {
		this.debugColor = makeColorString(colorName);
	}
}
