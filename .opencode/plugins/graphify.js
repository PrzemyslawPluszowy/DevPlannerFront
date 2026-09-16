// graphify OpenCode plugin
// Injects Graphify context automatically into chat and shell flows when the graph exists.
import { existsSync, readFileSync } from "fs";
import { join } from "path";

export const GraphifyPlugin = async ({ directory, $ }) => {
  let reminded = false;
  let memoryStored = false;
  const memoryHelperPath = join(process.env.HOME ?? "", ".local", "bin", "qdrant-memory");
  const graphReportPath = join(directory, "graphify-out", "GRAPH_REPORT.md");

  const readGraphContext = () => {
    if (!existsSync(graphReportPath)) return null;

    const report = readFileSync(graphReportPath, "utf8");
    const summaryLines = report
      .split("\n")
      .filter((line) =>
        line.startsWith("## God Nodes") ||
        line.startsWith("## Summary") ||
        line.startsWith("### Community") ||
        line.startsWith("- `")
      )
      .slice(0, 18);

    if (summaryLines.length === 0) return null;

    return [
      "[graphify] Knowledge graph available.",
      "Read graphify-out/GRAPH_REPORT.md for god nodes and architecture context before searching files.",
      ...summaryLines,
    ].join("\n");
  };

  return {
    "experimental.chat.system.transform": async (_input, output) => {
      const graphContext = readGraphContext();
      if (!graphContext) return;

      output.system.push(graphContext);
    },

    "command.execute.before": async (_input, output) => {
      const graphContext = readGraphContext();
      if (!graphContext) return;

      output.parts.unshift({ type: "text", text: `${graphContext}\n` });
    },

    "tool.execute.before": async (input, output) => {
      if (reminded) return;
      if (!readGraphContext()) return;

      if (input.tool === "bash") {
        output.args.command =
          'echo "[graphify] Knowledge graph available. Read graphify-out/GRAPH_REPORT.md for god nodes and architecture context before searching files." && ' +
          output.args.command;
        reminded = true;
      }
    },
    "session.idle": async () => {
      if (memoryStored) return;

      if (!existsSync(memoryHelperPath)) return;

      const summary = [
        "Sesja OpenCode zakończona.",
        "Repo: ready_next.",
        "Konfiguracja Graphify i lokalny Qdrant są aktywne.",
        "Następny krok: przy kolejnym pytaniu użyć graph-context albo memory-search.",
      ].join(" ");

      await $`${memoryHelperPath} store --source opencode-session --text ${summary}`;
      memoryStored = true;
    },
  };
};
