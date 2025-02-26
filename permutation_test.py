import pandas as pd
import numpy as np
import scipy.stats as stats


def read_csv(file_path):
    """Read CSV file and return the dataframe."""
    return pd.read_csv(file_path)


def calculate_z_scores(data):
    """Calculate the z-scores for the data."""
    return stats.zscore(data)


def permutation_test_single_gene(data, n_permutations=1000):
    """Perform permutation test for each gene weight."""
    original_z_scores = calculate_z_scores(data)
    permuted_z_scores = np.zeros((n_permutations, len(data)))

    for i in range(n_permutations):
        permuted_data = np.random.permutation(data)
        permuted_z_scores[i, :] = calculate_z_scores(permuted_data)

    p_values = np.mean(permuted_z_scores >= np.abs(original_z_scores), axis=0)

    return original_z_scores, p_values


def save_results(output_file, original_z_scores, p_values):
    """Save the results to a specified output file."""
    results = {
        'Gene Index': np.arange(len(original_z_scores)),
        'Original Z-Score': original_z_scores,
        'P-Value': p_values
    }
    results_df = pd.DataFrame(results)
    results_df.to_csv(output_file, index=False)


def main(input_file, output_file, n_permutations=1000):
    """Main function to execute the permutation test and save results."""
    data = read_csv(input_file)['weight']
    original_z_scores, p_values = permutation_test_single_gene(data.values.flatten(), n_permutations)
    save_results(output_file, original_z_scores, p_values)
    print(f"Results saved to {output_file}")


# Example usage
input_file = 'D:/GCN_classification/gut gene/pathway result/PLS1_gene.csv'
output_file = 'D:/GCN_classification/gut gene/pathway result/PLS1.csv'
n_permutations = 10000

main(input_file, output_file, n_permutations)
