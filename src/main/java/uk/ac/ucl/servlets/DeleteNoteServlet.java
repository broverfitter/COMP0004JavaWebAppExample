package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

import uk.ac.ucl.model.Tree;
import uk.ac.ucl.model.DirectoryNode;
import uk.ac.ucl.model.NoteNode;

@WebServlet("/deleteNote")
public class DeleteNoteServlet extends HttpServlet
{
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
            // This function receives the path needs to do different things depending on note or directory

            String id = request.getParameter("id");

            ServletContext context = getServletContext();
        
            // Load the tree structure
            String jsonFilePath = context.getRealPath("/structure.json");
            Tree tree = new Tree(jsonFilePath);
            DirectoryNode root = tree.getRoot();

            root.findAndDeleteChild(id);

            tree.saveToFile(jsonFilePath);

            // delete file from /notes
            String notePath = context.getRealPath("/notes/" + id);
            java.io.File file = new java.io.File(notePath);
            file.delete();

            response.setContentType("text/json");
            PrintWriter out = response.getWriter();

            out.println("{\"status\": \"success\"}");
  }
}