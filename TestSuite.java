import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Collection;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

@RunWith(Parameterized.class)
public class TestSuite {

	private final File file;

	public TestSuite(File file) {
		this.file = file;
	}

	@Test
	public void testGrammar() throws Exception {
		FileInputStream stream = new FileInputStream(this.file);
		ANTLRInputStream input = new ANTLRInputStream(stream);
		OOPSCLexer lexer = new OOPSCLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		OOPSCParser parser = new OOPSCParser(tokens);

		ParseTree tree = parser.program();
		assertEquals(0, parser.getNumberOfSyntaxErrors());
	}

	@Parameters(name = "{0}")
	public static Collection<Object[]> data() {
		final Collection<Object[]> data = new ArrayList<>();

		try {
			Files.walkFileTree(Paths.get("tests/"),
					new SimpleFileVisitor<Path>() {
						@Override
						public FileVisitResult visitFile(Path file,
								BasicFileAttributes attrs) throws IOException {
							if (file.toString().endsWith(".oops")) {
								data.add(new Object[] {
									file.toFile()
								});
							}
							return FileVisitResult.CONTINUE;
						}

						@Override
						public FileVisitResult visitFileFailed(Path file,
								IOException exc) throws IOException {
							return FileVisitResult.CONTINUE;
						}
					});
		} catch (IOException e) {
			e.printStackTrace();
		}

		return data;
	}

}