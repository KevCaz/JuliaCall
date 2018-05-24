output = IOBuffer()

out_terminal = Base.Terminals.TerminalBuffer(output)

basic_repl = Base.REPL.BasicREPL(out_terminal)

basic_display = Base.REPL.REPLDisplay(basic_repl)

# Base.pushdisplay(basic_display)

type DisplayManager
    repl_display :: Base.REPL.REPLDisplay
    location :: Int64
end

DisplayManager(repl_display :: Base.REPL.REPLDisplay) = DisplayManager(repl_display, 0)

function Rprint(s) ccall((:Rprintf,RCall.libR),Void,(Ptr{Cchar},), s) end

function proceed(dm :: DisplayManager)
    if dm.location < dm.repl_display.repl.terminal.out_stream.ptr-1
        Rprint(readstring(seek(dm.repl_display.repl.terminal.out_stream, dm.location)))
        dm.location = dm.repl_display.repl.terminal.out_stream.ptr-1
        Rprint("  \n")
    end
end

basic_display_manager = DisplayManager(basic_display)
