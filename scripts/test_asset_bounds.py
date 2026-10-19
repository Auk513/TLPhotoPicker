"""Run the production asset lookup against a strict collection without Photos/iOS."""
from pathlib import Path
import subprocess
import tempfile

source = (Path(__file__).resolve().parents[1] / "TLPhotoPicker/Classes/TLAssetsCollection.swift").read_text()
start = source.index("    func getAsset(at index: Int)")
end = source.index("    func getTLAsset", start)
method = source[start:end]

harness = """
struct PHAsset: Equatable { let id: Int }
struct FetchResult {
    let assets: [PHAsset]
    var count: Int { assets.count }
    func object(at index: Int) -> PHAsset { assets[index] }
}
struct Collection {
    var useCameraButton: Bool
    var fetchResult: FetchResult?
    METHOD
}
let assets = [PHAsset(id: 1), PHAsset(id: 2)]
for camera in [false, true] {
    for count in 0...2 {
        let collection = Collection(useCameraButton: camera,
                                    fetchResult: FetchResult(assets: Array(assets.prefix(count))))
        for index in -3...5 {
            let offset = index - (camera ? 1 : 0)
            let expected: PHAsset? = offset >= 0 && offset < count ? assets[offset] : nil
            assert(collection.getAsset(at: index) == expected,
                   "camera=\\(camera), count=\\(count), index=\\(index)")
        }
    }
    let unavailable = Collection(useCameraButton: camera, fetchResult: nil)
    assert(unavailable.getAsset(at: 0) == nil)
}
print("Asset bounds passed: empty/nonempty albums, negative/valid/past-end indices, camera offset, nil results")
""".replace("METHOD", method)

with tempfile.TemporaryDirectory() as directory:
    path = Path(directory) / "AssetBounds.swift"
    path.write_text(harness)
    subprocess.run(["swift", str(path)], check=True)
