package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.File;
import java.io.FileWriter;
import java.util.UUID;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import uk.ac.ucl.model.Tree;
import uk.ac.ucl.model.DirectoryNode;

// The servlet invoked to perform a search.
// The url http://localhost:8080/runsearch.html is mapped to calling doPost on the servlet object.
// The servlet object is created automatically, you just provide the class.

@WebServlet("/serveNote")
public class ServeNoteServlet extends HttpServlet
{
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
    String noteId = request.getParameter("id");
    
    String notesDir = getServletContext().getRealPath("/notes");
    File noteFile = new File(notesDir + "/" + noteId);

    String content = Files.readString(Path.of(noteFile.getPath()));

    ObjectMapper mapper = new ObjectMapper();
    ObjectNode responseJson = mapper.createObjectNode();

    responseJson.put("content", content);

    response.setContentType("application/json");
    mapper.writeValue(response.getOutputStream(), responseJson);
    }
}