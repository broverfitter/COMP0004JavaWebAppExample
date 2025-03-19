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

@WebServlet("/renameDir")
public class RenameDirServlet extends HttpServlet
{
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
            // This function receives the path needs to do different things depending on note or directory
            String oldPath = request.getParameter("dirPath");
            String newName = request.getParameter("newName");

            ServletContext context = getServletContext();

            String jsonFilePath = context.getRealPath("/structure.json");
            Tree tree = new Tree(jsonFilePath);

            tree.updateDirTitle(oldPath, newName);

            tree.saveToFile(jsonFilePath);

            response.setContentType("text/json");
            PrintWriter out = response.getWriter();
            out.println("{\"status\": \"success\"}");
  }
}