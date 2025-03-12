package uk.ac.ucl.servlets;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet("/note")
public class NoteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the note path from the query parameter

        String notePath = request.getParameter("path");
        ServletContext context = getServletContext();

        System.out.println(notePath);

        if (notePath != null) {
            // Read the note content from the file
            String realPath = context.getRealPath("notes/" + notePath);
            String noteContent = new String(Files.readAllBytes(Paths.get(realPath)));
            // Set the note content as a request attribute
            request.setAttribute("content", noteContent);
        } else {
            request.setAttribute("content", "Note not found.");
        }

        // Forward to the JSP page to display the note content
        context.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}