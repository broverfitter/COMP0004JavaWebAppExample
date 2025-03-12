package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uk.ac.ucl.model.DirectoryNode;
import uk.ac.ucl.model.Tree;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.UUID;

// The servlet invoked to perform a search.
// The url http://localhost:8080/runsearch.html is mapped to calling doPost on the servlet object.
// The servlet object is created automatically, you just provide the class.

@WebServlet("/savenote")
public class SaveNote extends HttpServlet
{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // returns the note that was saved
        String note = request.getParameter("note");
        String title = "note_" + UUID.randomUUID().toString() + ".txt";

        String notesDirectory = getServletContext().getRealPath("/notes");
        File directory = new File(notesDirectory);

        File noteFile = new File(directory, title);
        try (FileWriter writer = new FileWriter(noteFile)) {
            writer.write(note);
        }

        String jsonFilePath = getServletContext().getRealPath("/structure.json");

        Tree tree = new Tree(jsonFilePath);
        DirectoryNode root = tree.getRoot();

        tree.addNote("root", title, note);
        tree.saveToFile(jsonFilePath);

        request.setAttribute("tree", root);
        response.sendRedirect("/");
    }
}