# Main entry point for all huggingface operations

from src.hfrepo import hf_repo_ops
from src.hfspace import hf_space_ops

def main():
    # hf_space_ops()
    hf_repo_ops()


if __name__ == "__main__":
    main()
