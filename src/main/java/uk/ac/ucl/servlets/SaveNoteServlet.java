package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.UUID;

import uk.ac.ucl.model.Tree;
import uk.ac.ucl.model.DirectoryNode;

// The servlet invoked to perform a search.
// The url http://localhost:8080/runsearch.html is mapped to calling doPost on the servlet object.
// The servlet object is created automatically, you just provide the class.

@WebServlet("/saveNote")
@MultipartConfig
public class SaveNoteServlet extends HttpServlet
{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    ServletContext context = getServletContext();
    String titleContent = request.getParameter("titleContent");
    String noteContent = request.getParameter("noteContent");
    String notePath = request.getParameter("notePath");
    String noteId = request.getParameter("noteId");

    String jsonFilePath = context.getRealPath("/structure.json");
    Tree tree = new Tree(jsonFilePath);

    String filename;

    if (notePath == null || notePath.isEmpty()) {
        notePath = "root/";
    }

    if (noteId == null || noteId.isEmpty()) {
        noteId = UUID.randomUUID().toString();
        filename = noteId + ".html";

        tree.saveNote(filename, titleContent, notePath);
    } else {
        filename = noteId;
        tree.updateNoteTitle(notePath, filename, titleContent);
    }

    File noteFile = new File(context.getRealPath("/notes/" + filename));
    try (FileWriter writer = new FileWriter(noteFile)) {
        writer.write(noteContent);
    }

    tree.saveToFile(jsonFilePath);

    // Set the content type of the response to JSON
    response.setContentType("application/json");

    // Get a PrintWriter to write data to the response
    PrintWriter out = response.getWriter();

    // Write a JSON string containing the status and noteId
    out.print("{\"status\": \"success\", \"noteId\": \"" + filename + "\"}");

    // Flush the output stream to ensure all data is sent
    out.flush();
}
}