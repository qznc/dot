set unwindonsignal on

# FIRM

# The following is able to print most important firm datastructures:
# ir_node*, tarval*, ir_type*, ir_mode* and maybe others should work 
define irn
print gdb_node_helper($arg0)
end

# Hack to display the length of a firm ARR_F or ARR_D
define arrlen
p ((ir_arr_descr*)((char*)($arg0) - ((char*)&((ir_arr_descr*)0)->v - ((char*)0))))->nelts
end

# The following should be used for libfirm after 1.18.0
define dump
call dump_ir_graph(current_ir_graph, "XXX")
end

# The following 2 macros make sense for libfirm until 1.18.0
#define dumps
#call dump_ir_block_graph_sched(current_ir_graph, "-XXS")
#end
#
#define dumpx
#call dump_ir_block_graph(current_ir_graph, "-XXX")
#end

define firmd
call firm_debug($arg0)
end

define graph
print gdb_node_helper(current_ir_graph)
end

define keep
call add_End_keepalive(get_irg_end(current_ir_graph), $arg0)
end

define pred
print gdb_node_helper(get_irn_n($arg0, $arg1))
end

# cparser
define expr
call print_expression($arg0), (void)putchar('\n')
end

define stmt
call print_statement($arg0)

define type
call print_type($arg0), (void)putchar('\n')
end

# If you want to run java programs in gdb, then you should make sure
# that gdb ignores some unix signals that java reroutes and expects to
# receive. If gdb intercepts these the java program won't work.  The easy
# way to do this is to add this macro to your .gdbinit and start it before
# running any java programs. (We advice against this for non-java programs,
# since it hides most segfaults from gdb)
define javadebug
handle SIGUSR1 nostop noprint pass
handle SIGSEGV nostop noprint pass
handle SIGILL nostop noprint pass
handle SIGQUIT nostop noprint pass
end

define x10debug
set print static-members off
break x10aux::throwNPE
break x10aux::throwBPE
break x10aux::throwArrayIndexOutOfBoundsException
break x10aux::throwOOME
handle SIGPWR SIGXCPU nostop noprint
handle SIG39 nostop noprint
handle SIG40 nostop noprint
end

define octoposdebug
handle SIG44 nostop noprint
handle SIG46 nostop noprint
handle SIG35 nostop noprint
#set follow-fork-mode child
end
